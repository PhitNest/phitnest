export interface IDatabase {
  connect(host: string): Promise<void>;

  disconnect(): Promise<void>;

  dropDatabase(): Promise<void>;
}
