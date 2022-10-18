import axios from "axios";
import { Request, Response, NextFunction } from "express";
import l from "../../common/logger";

class LocationMiddleware {
  locationFromAddress(req: Request, res: Response, next: NextFunction) {
    axios
      .get("https://nominatim.openstreetmap.org/search", {
        params: {
          q: `${req.body.address.street}, ${req.body.address.city}, ${req.body.address.state} ${req.body.address.zipCode}`.replace(
            /%20/g,
            "+"
          ),
          format: "json",
          polygon: 1,
          addressdetails: 1,
        },
      })
      .then((mapResponse) => {
        if (mapResponse.data && mapResponse.data.length > 0) {
          const { lon, lat } = mapResponse.data[0];
          res.locals.location = {
            type: "Point",
            coordinates: [lon, lat],
          };
          l.info(`Address was mapped to coordinates: ${lon}, ${lat}`);
          next();
        } else {
          l.error("Address could not be mapped to coordinates");
          next({ message: "This address could not be located." });
        }
      });
  }
}

export default new LocationMiddleware();
