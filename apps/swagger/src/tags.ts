import type {oas31 as opentype} from "openapi3-ts"

export const tags : opentype.TagObject[] = [
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
];