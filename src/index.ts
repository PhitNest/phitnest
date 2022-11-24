import { connect } from "./common/database";
import { inject } from "./common/dependency-injection";
import { createServer } from "./common/express/server";

connect().then(inject).then(createServer);
