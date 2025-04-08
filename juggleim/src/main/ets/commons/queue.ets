
class SingleThreadQueue {
  private taskQueue: Array<() => Promise<void>> = [];
  private isProcessing: boolean = false;

  addTask(task: () => Promise<void>): void {
    this.taskQueue.push(task);
    if (!this.isProcessing) {
      this.processQueue();
    }
  }

  private async processQueue(): Promise<void> {
    this.isProcessing = true;
    while (this.taskQueue.length > 0) {
      const currentTask = this.taskQueue.shift();
      if (currentTask) {
        try {
          await currentTask();
        } catch (error) {
          console.error('任务执行出错:', error);
        }
      }
    }
    this.isProcessing = false;
  }
}