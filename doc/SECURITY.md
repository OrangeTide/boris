# Secure Programming Principles

- Never trust external input.
- Always use parameterized queries and records. For building JSON or SQL, use printf or shell-like variable expansion; don't use concatenation that can be easily injected by malicious input.
- Apply the principle of least privilege. Every system component should only have the minimum permissions required to do its job.
- Passwords must never be stored in plain text. If a temporary buffer must contain a password, erase that buffer as soon as practically possible. On-disk and in-cache data must use a password hash technique.
- Sensitive data must be protected both in transit and at rest. Don't let a user dump their own password hash. Don't let one user browse the private details of another user (name, email).
- Never hardcode secrets. API keys and the like belong in a dotenv system, not in code, not in the command-line options, not in a checked-in config file.
- Avoid information leakage in error messages. Printing a plain-text password in an error message is not acceptable. Error messages that could leak private information (name, email, IP address) to another user is not acceptable; in general printing a person's real name or email is unnecessary in an error message.
- Sanitize output to prevent XSS -- this applies because we have an embedded web server.
- Keep dependencies secure. There must be a process in place to monitor third-party dependencies for security bulletins. Snyk, Trivy, Dependabot, etc. Best practices: scanning vulnerabilities in CI pipelines, avoiding unmaintained libraries, regularly updating dependencies.
- Log and monitor security events. Failed login attempts, authentication failures, permission changes, unusual API requests. Logs should then be analyzed by observability systems such as: Prometheus, Grafana, Elastic Stack.
