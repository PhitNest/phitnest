export interface IResponse<ResType = any, LocalsType = any> {
  locals: LocalsType;

  status(code: number): this;
  json(content: ResType): this;
}
