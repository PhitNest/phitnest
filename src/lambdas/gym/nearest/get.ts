let response

/**
 * Get user
 */
export const nearestGyms = async (): Promise<{
  statusCode: number
  body: string
}> => {
  try {
    response = {
      statusCode: 200,
      body: "hey"
    }
  } catch (err: any) {
    response = {
      statusCode: 500,
      body: err.message
    }
  }

  return response
}