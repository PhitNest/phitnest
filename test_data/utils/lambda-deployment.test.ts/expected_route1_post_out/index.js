"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.invoke = void 0;
const transpileThis_1 = require("./common/nested/transpileThis");
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
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibW9kdWxlLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsibW9kdWxlLnRzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7OztBQUNBLGlFQUF5RDtBQUN6RCxtQ0FBMkI7QUFDM0IscUNBQTZCO0FBRXRCLEtBQUssVUFBVSxNQUFNLENBQzFCLEtBQTRCO0lBRTVCLE9BQU87UUFDTCxVQUFVLEVBQUUsSUFBQSxnQkFBSyxFQUFDLElBQUksQ0FBQyxLQUFLLENBQUMsS0FBSyxDQUFDLElBQUksSUFBSSx3QkFBUSxDQUFDLENBQUMsR0FBRyxJQUFJLENBQUMsQ0FBQztZQUM1RCxDQUFDLENBQUMsR0FBRztZQUNMLENBQUMsQ0FBQyxJQUFBLGlCQUFNLEVBQUMsSUFBSSxDQUFDLEtBQUssQ0FBQyxLQUFLLENBQUMsSUFBSSxJQUFJLEVBQUUsQ0FBQyxDQUFDLEdBQUcsSUFBSSxDQUFDLENBQUM7Z0JBQy9DLENBQUMsQ0FBQyxHQUFHO2dCQUNMLENBQUMsQ0FBQyxHQUFHO1FBQ1AsSUFBSSxFQUFFLElBQUksQ0FBQyxTQUFTLENBQUMsS0FBSyxDQUFDO0tBQzVCLENBQUM7QUFDSixDQUFDO0FBWEQsd0JBV0MiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBBUElHYXRld2F5UHJveHlSZXN1bHQgfSBmcm9tIFwiYXdzLWxhbWJkYVwiO1xuaW1wb3J0IHsgbXlTdHJpbmcgfSBmcm9tIFwiLi9jb21tb24vbmVzdGVkL3RyYW5zcGlsZVRoaXNcIjtcbmltcG9ydCBpc09kZCBmcm9tIFwiaXMtb2RkXCI7XG5pbXBvcnQgaXNFdmVuIGZyb20gXCJpcy1ldmVuXCI7XG5cbmV4cG9ydCBhc3luYyBmdW5jdGlvbiBpbnZva2UoXG4gIGV2ZW50OiBBUElHYXRld2F5UHJveHlSZXN1bHRcbik6IFByb21pc2U8QVBJR2F0ZXdheVByb3h5UmVzdWx0PiB7XG4gIHJldHVybiB7XG4gICAgc3RhdHVzQ29kZTogaXNPZGQoSlNPTi5wYXJzZShldmVudC5ib2R5IHx8IG15U3RyaW5nKS5hZ2UgfHwgMylcbiAgICAgID8gMjAwXG4gICAgICA6IGlzRXZlbihKU09OLnBhcnNlKGV2ZW50LmJvZHkgfHwgXCJcIikuYWdlIHx8IDQpXG4gICAgICA/IDIwMFxuICAgICAgOiA1MDAsXG4gICAgYm9keTogSlNPTi5zdHJpbmdpZnkoZXZlbnQpLFxuICB9O1xufVxuIl19