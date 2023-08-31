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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibW9kdWxlLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsibW9kdWxlLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUNBLGFBQWE7QUFDYiwrREFBdUQ7QUFDdkQsbUNBQTJCO0FBQzNCLHFDQUE2QjtBQUV0QixLQUFLLFVBQVUsTUFBTSxDQUMxQixLQUE0QjtJQUU1QixPQUFPO1FBQ0wsVUFBVSxFQUFFLElBQUEsZ0JBQUssRUFBQyxJQUFJLENBQUMsS0FBSyxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksd0JBQVEsQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDLENBQUM7WUFDNUQsQ0FBQyxDQUFDLEdBQUc7WUFDTCxDQUFDLENBQUMsSUFBQSxpQkFBTSxFQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSxFQUFFLENBQUMsQ0FBQyxHQUFHLElBQUksQ0FBQyxDQUFDO2dCQUMvQyxDQUFDLENBQUMsR0FBRztnQkFDTCxDQUFDLENBQUMsR0FBRztRQUNQLElBQUksRUFBRSxJQUFJLENBQUMsU0FBUyxDQUFDLEtBQUssQ0FBQztLQUM1QixDQUFDO0FBQ0osQ0FBQztBQVhELHdCQVdDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgQVBJR2F0ZXdheVByb3h5UmVzdWx0IH0gZnJvbSBcImF3cy1sYW1iZGFcIjtcbi8vIEB0cy1pZ25vcmVcbmltcG9ydCB7IG15U3RyaW5nIH0gZnJvbSBcImNvbW1vbi9uZXN0ZWQvdHJhbnNwaWxlVGhpc1wiO1xuaW1wb3J0IGlzT2RkIGZyb20gXCJpcy1vZGRcIjtcbmltcG9ydCBpc0V2ZW4gZnJvbSBcImlzLWV2ZW5cIjtcblxuZXhwb3J0IGFzeW5jIGZ1bmN0aW9uIGludm9rZShcbiAgZXZlbnQ6IEFQSUdhdGV3YXlQcm94eVJlc3VsdFxuKTogUHJvbWlzZTxBUElHYXRld2F5UHJveHlSZXN1bHQ+IHtcbiAgcmV0dXJuIHtcbiAgICBzdGF0dXNDb2RlOiBpc09kZChKU09OLnBhcnNlKGV2ZW50LmJvZHkgfHwgbXlTdHJpbmcpLmFnZSB8fCAzKVxuICAgICAgPyAyMDBcbiAgICAgIDogaXNFdmVuKEpTT04ucGFyc2UoZXZlbnQuYm9keSB8fCBcIlwiKS5hZ2UgfHwgNClcbiAgICAgID8gMjAwXG4gICAgICA6IDUwMCxcbiAgICBib2R5OiBKU09OLnN0cmluZ2lmeShldmVudCksXG4gIH07XG59XG4iXX0=