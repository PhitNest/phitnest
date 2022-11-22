export interface IResponse<LocalsType = any> {
  locals: LocalsType;

  status(code: number): this;
  json(content: any): this;
}
