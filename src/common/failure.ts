export class Failure {
    statusCode = 500 as const;
    message: string;
    name: string;
    body: string;

    constructor(name: string, message: string) {
        this.name = name;
        this.message = message;
        this.body = JSON.stringify({
            name: this.name,
            message: this.message,
        });
    }
}