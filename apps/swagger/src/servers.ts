import type {oas31 as opentype} from "openapi3-ts";


export const servers: opentype.ServerObject[] = [
    {
        "description": "SwaggerHub API Auto Mocking",
        "url": "https://virtserver.swaggerhub.com/CAGLARKULLU_1/Demo/1.0.0"
    },
    {
        "url": "https://api.phitnest.com",
        "description": "Production server"
    },
    {
        "url": "http://localhost:3000",
        "description": "Local server"
    }
];