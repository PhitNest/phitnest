import {OpenAPIHono} from '@hono/zod-openapi'
import {serve} from "@hono/node-server";
import {swaggerUI} from "@hono/swagger-ui";
import registerPaths from "./routes/route";
import registerSchemas from "./schemas/schema";

const app = new OpenAPIHono()
registerPaths(app)
registerSchemas(app)

// Middleware to serve the Swagger-UI at /api-doc
app.use('/api-doc', swaggerUI({url: '/doc-json'}))

// The OpenAPI documentation will be available at /doc
app.doc('/doc-json', {
    openapi: '3.0.0',
    info: {
        title: "apps/backend/rest-api",
        description: "Backend Represetation of GoldNest",
        version: "1.0.0"
    },
    servers: [
        {
            "description": "SwaggerHub API Auto Mocking",
            "url": "https://virtserver.swaggerhub.com/CAGLARKULLU_1/Demo/1.0.0"
        },
        {
            "url": "http://api.yourdomain.com/v1",
            "description": "Production server"
        }
    ],
    tags: [
        {
            name: "User Management",
            description: "Operations related to user account management."
        },
        {
            name: "Friend Requests",
            description: "Operations for managing friend requests."
        },
        {
            name: "Messaging",
            description: "Operations related to user messaging."
        },
        {
            name: "Reporting",
            description: "Operations for reporting.route.ts users or content."
        },
        {
            name: "Logging",
            description: "Operations for submitting and managing log events."
        },
        {
            name: "Home Data",
            description: "Operations for fetching home screen data."
        },
    ],
})


const PORT = parseInt(process.env.PORT || "") || 3000
serve({
    fetch: app.fetch,
    port: PORT
}, () => console.log(`🌐Server is running on port ${PORT}`))