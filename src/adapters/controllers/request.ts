export interface IRequest<ReqType = any> {
  content(): ReqType;
  authorization(): string;
}
