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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibW9kdWxlLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsibW9kdWxlLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUNBLGFBQWE7QUFDYiwrREFBdUQ7QUFDdkQsbUNBQTJCO0FBQzNCLHFDQUE2QjtBQUV0QixLQUFLLFVBQVUsTUFBTSxDQUMxQixLQUE0QjtJQUU1QixPQUFPO1FBQ0wsVUFBVSxFQUFFLElBQUEsZ0JBQUssRUFBQyxJQUFJLENBQUMsS0FBSyxDQUFDLEtBQUssQ0FBQyxJQUFJLElBQUksd0JBQVEsQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDLENBQUM7WUFDNUQsQ0FBQyxDQUFDLEdBQUc7WUFDTCxDQUFDLENBQUMsSUFBQSxpQkFBTSxFQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSxFQUFFLENBQUMsQ0FBQyxHQUFHLElBQUksQ0FBQyxDQUFDO2dCQUMvQyxDQUFDLENBQUMsR0FBRztnQkFDTCxDQUFDLENBQUMsR0FBRztRQUNQLElBQUksRUFBRSxJQUFJLENBQUMsU0FBUyxDQUFDLEtBQUssQ0FBQztLQUM1QixDQUFDO0FBQ0osQ0FBQztBQVhELHdCQVdDIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgQVBJR2F0ZXdheVByb3h5UmVzdWx0IH0gZnJvbSBcImF3cy1sYW1iZGFcIjtcclxuLy8gQHRzLWlnbm9yZVxyXG5pbXBvcnQgeyBteVN0cmluZyB9IGZyb20gXCJjb21tb24vbmVzdGVkL3RyYW5zcGlsZVRoaXNcIjtcclxuaW1wb3J0IGlzT2RkIGZyb20gXCJpcy1vZGRcIjtcclxuaW1wb3J0IGlzRXZlbiBmcm9tIFwiaXMtZXZlblwiO1xyXG5cclxuZXhwb3J0IGFzeW5jIGZ1bmN0aW9uIGludm9rZShcclxuICBldmVudDogQVBJR2F0ZXdheVByb3h5UmVzdWx0XHJcbik6IFByb21pc2U8QVBJR2F0ZXdheVByb3h5UmVzdWx0PiB7XHJcbiAgcmV0dXJuIHtcclxuICAgIHN0YXR1c0NvZGU6IGlzT2RkKEpTT04ucGFyc2UoZXZlbnQuYm9keSB8fCBteVN0cmluZykuYWdlIHx8IDMpXHJcbiAgICAgID8gMjAwXHJcbiAgICAgIDogaXNFdmVuKEpTT04ucGFyc2UoZXZlbnQuYm9keSB8fCBcIlwiKS5hZ2UgfHwgNClcclxuICAgICAgPyAyMDBcclxuICAgICAgOiA1MDAsXHJcbiAgICBib2R5OiBKU09OLnN0cmluZ2lmeShldmVudCksXHJcbiAgfTtcclxufVxyXG4iXX0=