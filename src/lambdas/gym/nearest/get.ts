import { respond } from "@/common/respond";
import { useDgraph } from "@/common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";
const gql = String.raw;

const validator = z.object({
  longitude: z.number().min(-180).max(180),
  latitude: z.number().min(-90).max(90),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    body: event.queryStringParameters,
    validator: validator,
    controller: (body: z.infer<typeof validator>) => {
      return useDgraph(async (client) => {
        const txn = client.newTxn();
        await txn.mutate({
          setJson: { name: "Alice", age: 26 },
          commitNow: true,
        });
        const res = await txn.queryWithVars(
          gql`
            query all($a: string) {
              all(func: eq(name, $a)) {
                name
              }
            }
          `,
          { $a: "Alice" }
        );
        return `${res.data}${body}`;
      });
    },
  });
}
