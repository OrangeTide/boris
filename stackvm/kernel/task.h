#ifndef TASK_H_
#define TASK_H_

struct task;
struct task_channel;

struct task *task_new(const char *id, void *extra, void (*run)(void*), void (*free)(void*));
void *task_extra(struct task *task);
int task_empty(struct task *task);
void task_free(struct task *task);
int task_schedule(struct task *task, struct task_channel *chan);

struct task_channel *task_channel_new(const char *id);
struct task *task_channel_next(struct task_channel *chan);
#endif
