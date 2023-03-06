import { Failure } from "./failure";

function errorResponse(error: any): {
  statusCode: number;
  body: any;
} {
  return {
    statusCode: 500,
    body: error,
  };
}

function successResponse(body: any): {
  statusCode: number;
  body: any;
} {
  return {
    statusCode: 200,
    body: body,
  };
}

export async function respond(controller: () => Promise<any>): Promise<{
  statusCode: number;
  body: any;
}> {
  try {
    const response = await controller();
    if (response instanceof Failure) {
      return errorResponse(response);
    } else {
      return successResponse(response);
    }
  } catch (error: any) {
    return errorResponse(error);
  }
}
