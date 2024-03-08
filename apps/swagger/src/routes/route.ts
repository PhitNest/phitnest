import {OpenAPIHono} from "@hono/zod-openapi";
import {deleteUserRoute, exploreUsersRoute} from "./userManagement.route";
import {deleteFriendRequestRoute, sendFriendRequestRoute} from "./friendRequest.route";
import {conversationRoute} from "./messaging.route";
import {getReportRoute, postReportRoute} from "./reporting.route";
import {loggingRoute} from "./logging.route";
import {getHomeDataRoute} from "./homeData.route";
import {Context} from "hono";


const app = new OpenAPIHono()

// @ts-ignore
app.openapi(deleteUserRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(exploreUsersRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(sendFriendRequestRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(deleteFriendRequestRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(conversationRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(getReportRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(postReportRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(loggingRoute, (c: Context) => {
    return c.json({})
})

// @ts-ignore
app.openapi(getHomeDataRoute, (c: Context) => {
    return c.json({})
})

export default app