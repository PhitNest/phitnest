export class Failure {
  name: string;
  message: string;
  data: any;

  constructor(name: string, message: string, data?: any) {
    this.name = name;
    this.message = message;
    this.data = data;
  }
}
