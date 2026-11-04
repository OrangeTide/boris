# Kobold-Pascal Properties (uniform access)

This note describes `property`: an accessor-backed value that looks like a variable at
every use site but is implemented by routines. It follows the uniform access principle,
so a consumer cannot tell, and does not need to know, whether it is reading a stored cell
or a computed value.

> Status: implemented (routine-reference accessors), for scalar values, reference-counted
> handles, and inline aggregate values. The declaration-level property and the computed record
> field both work: a read becomes a call to the getter, a write a call to the setter, and a
> property with only `read` is read-only. A handle-typed property (a string, a dynamic array, a
> map, an interface, or a process) returns the handle with its reference owned, so a read
> transfers ownership exactly like any handle-returning call. An aggregate-typed property (a
> record, a fixed array, or a large set) returns its value through the getter's caller-provided
> storage (sret), the same path an aggregate-returning function uses, so a read yields the
> value's address and a field or element of a record property reads through it. Units do not
> require any of this: a unit exports plain `var` and `const`, and can use a `property` once
> this feature exists.
>
> Deferred: a property in a unit's exported interface (cross-module, which needs interface
> emission and inlining); and the inline accessor syntax below. The accessors are a parameterless
> getter and a one-argument setter; for a computed field they are methods of the record, resolved
> at the use site like any method, so an accessor may be declared after the field.

## The surface

A `property` declares a `read` accessor and an optional `write` accessor:

```pascal
property volume: integer read getVolume write setVolume;  { read and write }
property level: integer read getLevel;                    { read-only to consumers }
property mixDown: Sample read computeMix;                  { computed, no storage }
```

Access control falls out of which accessors exist: a property with only `read` is
read-only across the boundary, which is the read-shared, write-owned pattern. There is no
separate access-control keyword; the presence or absence of `write` is the control.

## Uniform access and the ABI

At the use site a property reads and writes exactly like a variable. At the ABI a property
access is a call to its accessor by default, resolved at link the same way a routine import
is. Because the use site does not change, a unit can start with a plain `var` and later
replace it with a `property` of the same name: the use-site source is unchanged, only the
ABI changes, so consumers recompile but do not edit.

A call per read is not the whole story. For a trivial accessor, a getter that just returns
a field, or the deferred lambda form below, the object format can carry the accessor body
in the module's interface so the consumer inlines it across the unit boundary. A property
read then lowers to the same load a `var` access would, with no call. It reuses the
interface inlining mechanism units use for an inline `const`, where the value rides the
interface and the consumer bakes it in (see the Mapping to KPM1 section of `kp-units.md`).
An inlined
accessor body is consumer-observable, so it is part of the interface fingerprint: change
the body and the consumers that inlined it must recompile, exactly like a changed inline
const.

The accessor bodies live in the implementation part of the exporting unit, or on the owning
unit for a record field. Inline accessor bodies are a deferred future form, likely
lambda-shaped (for example `read () => hardwareVolume()`); the routine-reference form above
is the surface for now.

## Computed record fields

A `property` may also be a record field, giving computed fields:

```pascal
type Sprite = record
    x, y: real;
    bounds: Rect read computeBounds;   { computed field }
end;
```

A computed field reads like a stored field but runs its accessor. The same read/write
rule applies: a field with only `read` is read-only.

## Relationship to `const` and link-time values

A `property` is for computed or validated access, backed by a routine and a call per read.
It is not the way to expose a plain changeable constant. A scalar value that a foundation
library wants to change with a relink is a link-time constant symbol, a `const` resolved
at link, not a property (see the Constants section of `kp-units.md`). Reserve `property`
for the cases that genuinely need an accessor.

## Open questions

- **Inline accessor syntax.** The routine-reference form (`read getX write setX`) is the
  surface now; an inline, likely lambda-shaped form is a later addition.
- **Property types (done).** A property or computed field may carry a scalar value (an ordinal,
  a real, or a 64-bit integer), a reference-counted handle (a string, a dynamic array, a map, an
  interface, or a process), or an inline aggregate (a record, a fixed array, or a large set). A
  handle read transfers its owned reference like any handle-returning call; an aggregate read
  returns through the getter's sret buffer, the same path an aggregate-returning function uses.
- **Cross-module properties.** A property in a unit's exported interface needs the interface
  emission and inlining described above; for now a property is module-private. The accessor
  bodies live in the same program or unit as the property.

## See also

- `kp-units.md` the unit and separate-compilation design (exports `var` and `const`).
- `kp-grammar.md` the reserved words and the deferred property productions.
- `kobold.md` the language and runtime design.
