import { Context, APIGatewayEvent } from 'aws-lambda';


/**
 * Get user
*/
export const nearestGyms = async (event: APIGatewayEvent, context: Context): Promise<{
  statusCode: number
  body: string
}> => {
  try {
    return  {
      statusCode: 200,
      body: `Event: ${JSON.stringify(event, null, 2)}\nContext: ${JSON.stringify(context, null, 2)}`
    }
  } catch (err: any) {
    return {
      statusCode: 500,
      body: err.message
    }
  }
}