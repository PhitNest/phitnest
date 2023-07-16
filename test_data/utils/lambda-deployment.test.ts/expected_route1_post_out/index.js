"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.invoke = void 0;
// @ts-ignore
const transpileThis_1 = require("common/nested/transpileThis");
const is_odd_1 = require("is-odd");
const is_even_1 = require("is-even");
async function invoke(event) {
    return {
        statusCode: (0, is_odd_1.default)(JSON.parse(event.body || transpileThis_1.myString).age || 3)
            ? 200
            : (0, is_even_1.default)(JSON.parse(event.body || "").age || 4)
                ? 200
                : 500,
        body: JSON.stringify(event),
    };
}
exports.invoke = invoke;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibW9kdWxlLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsibW9kdWxlLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUNBLGFBQWE7QUFDYixpRUFBeUQ7QUFDekQsbUNBQTJCO0FBQzNCLHFDQUE2QjtBQUV0QixLQUFLLFVBQVUsTUFBTSxDQUMxQixLQUE0QjtJQUU1QixPQUFPO1FBQ0wsVUFBVSxFQUFFLElBQUEsZ0JBQUssRUFBQyxJQUFJLENBQUMsS0FBSyxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksd0JBQVEsQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDLENBQUM7WUFDNUQsQ0FBQyxDQUFDLEdBQUc7WUFDTCxDQUFDLENBQUMsSUFBQSxpQkFBTSxFQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSxFQUFFLENBQUMsQ0FBQyxHQUFHLElBQUksQ0FBQyxDQUFDO2dCQUMvQyxDQUFDLENBQUMsR0FBRztnQkFDTCxDQUFDLENBQUMsR0FBRztRQUNQLElBQUksRUFBRSxJQUFJLENBQUMsU0FBUyxDQUFDLEtBQUssQ0FBQztLQUM1QixDQUFDO0FBQ0osQ0FBQztBQVhELHdCQVdDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgQVBJR2F0ZXdheVByb3h5UmVzdWx0IH0gZnJvbSBcImF3cy1sYW1iZGFcIjtcbi8vIEB0cy1pZ25vcmVcbmltcG9ydCB7IG15U3RyaW5nIH0gZnJvbSBcIi4vY29tbW9uL25lc3RlZC90cmFuc3BpbGVUaGlzXCI7XG5pbXBvcnQgaXNPZGQgZnJvbSBcImlzLW9kZFwiO1xuaW1wb3J0IGlzRXZlbiBmcm9tIFwiaXMtZXZlblwiO1xuXG5leHBvcnQgYXN5bmMgZnVuY3Rpb24gaW52b2tlKFxuICBldmVudDogQVBJR2F0ZXdheVByb3h5UmVzdWx0XG4pOiBQcm9taXNlPEFQSUdhdGV3YXlQcm94eVJlc3VsdD4ge1xuICByZXR1cm4ge1xuICAgIHN0YXR1c0NvZGU6IGlzT2RkKEpTT04ucGFyc2UoZXZlbnQuYm9keSB8fCBteVN0cmluZykuYWdlIHx8IDMpXG4gICAgICA/IDIwMFxuICAgICAgOiBpc0V2ZW4oSlNPTi5wYXJzZShldmVudC5ib2R5IHx8IFwiXCIpLmFnZSB8fCA0KVxuICAgICAgPyAyMDBcbiAgICAgIDogNTAwLFxuICAgIGJvZHk6IEpTT04uc3RyaW5naWZ5KGV2ZW50KSxcbiAgfTtcbn1cbiJdfQ==