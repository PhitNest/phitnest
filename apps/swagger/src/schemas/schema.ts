import {OpenAPIHono} from '@hono/zod-openapi'
import {ReportUserSchema} from "./reportUser.schema";
import {MessageSchema} from "./message.schema";
import {LogEventSchema} from "./log.schema";
import {FriendRequestSchema} from "./friendRequest.schema";
import {UserDataSchema} from "./userData.schema";
import {UserSchema} from './user.schema';

export default function registerSchemas(app: OpenAPIHono): void {
    app.openAPIRegistry.register("User", UserSchema)
    app.openAPIRegistry.register("UserData", UserDataSchema)
    app.openAPIRegistry.register("FriendRequest", FriendRequestSchema)
    app.openAPIRegistry.register("LogEvent", LogEventSchema)
    app.openAPIRegistry.register("Message", MessageSchema)
    app.openAPIRegistry.register("ReportUser", ReportUserSchema)
}
