import {OpenAPIHono} from "@hono/zod-openapi";
import {deleteUserRoute, exploreUsersRoute} from "./userManagement.route";
import {deleteFriendRequestRoute, sendFriendRequestRoute} from "./friendRequest.route";
import {conversationRoute} from "./messaging.route";
import {getReportRoute, postReportRoute} from "./reporting.route";
import {loggingRoute} from "./logging.route";
import {getHomeDataRoute} from "./homeData.route";

export default function registerPaths(app: OpenAPIHono): void {
    // @ts-ignore
    app.openapi(deleteUserRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(exploreUsersRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(sendFriendRequestRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(deleteFriendRequestRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(conversationRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(getReportRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(postReportRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(loggingRoute, (c) => {
        return c.json({})
    })

    // @ts-ignore
    app.openapi(getHomeDataRoute, (c) => {
        return c.json({})
    })
}