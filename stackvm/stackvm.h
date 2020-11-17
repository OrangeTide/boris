#ifndef STACKVM_H
#define STACKVM_H
/* flags for vm.status
 * bit set means an error.
 */
#define VM_ERROR_INVALID_OPCODE		(1 << 1) /* 0x2 */
#define VM_ERROR_STACK_UNDERFLOW	(1 << 2) /* 0x4 */
#define VM_ERROR_STACK_OVERFLOW		(1 << 3) /* 0x8 */
#define VM_ERROR_SYSCALL		(1 << 4) /* 0x10 */
#define VM_ERROR_END_OF_FILE		(1 << 5) /* 0x20 */
#define VM_ERROR_OUT_OF_BOUNDS		(1 << 6) /* 0x40 */
#define VM_ERROR_MATH_ERROR		(1 << 7) /* 0x80 */
#define VM_ERROR_UNALIGNED		(1 << 9) /* 0x200 */
#define VM_ERROR_NOT_INITIALIZED	(1 << 10) /* 0x400 */
#define VM_ERROR_BAD_ENVIRONMENT	(1 << 11) /* 0x800 */
#define VM_ERROR_BAD_SYSCALL		(1 << 12) /* 0x1000 */
#define VM_ERROR_ABORT			(1 << 13) /* 0x2000 */
#define VM_STATUS_FINISHED		(0) /* 0x0 - no bits set means success */

typedef unsigned vmword_t;
typedef float vmsingle_t;

struct vm_env;
struct vm;

struct vm_env *vm_env_new(unsigned nr_syscalls);
int vm_env_register(struct vm_env *env, int syscall_num, void (*sc)(struct vm *vm));
void vm_disassemble(const struct vm *vm);
int vm_run_slice(struct vm *vm);
void vm_call(struct vm *vm, vmword_t entry, unsigned nr_args, ...);
void vm_call_array(struct vm *vm, vmword_t entry, unsigned nr_args, const vmword_t args[]);
void vm_free(struct vm *vm);
struct vm *vm_new(const struct vm_env *env);
int vm_load(struct vm *vm, const char *filename);
int vm_status(const struct vm *vm);
const char *vm_filename(const struct vm *vm);
vmword_t vm_pop(struct vm *vm);
vmsingle_t vm_popf(struct vm *vm);
void vm_push(struct vm *vm, vmword_t n);
void vm_pushf(struct vm *vm, vmsingle_t f);
vmword_t vm_arg(struct vm *vm, int num);
char *vm_string(struct vm *vm, vmword_t addr, size_t *len);
void vm_abort(struct vm *vm);
void *vm_get_extra(struct vm *vm);
void *vm_set_extra(struct vm *vm, void *p);
void vm_yield(struct vm *vm);
#endif
