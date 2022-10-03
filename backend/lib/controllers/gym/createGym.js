const { StatusOK, StatusBadRequest } = require("../../constants");
const axios = require("axios");
const { gym } = require("../../schema");

module.exports = async (req, res) => {
  const mapResponse = await axios.get(
    "https://nominatim.openstreetmap.org/search",
    {
      params: {
        q: `${req.body.address.street}, ${req.body.address.city}, ${req.body.address.state} ${req.body.address.zipCode}`.replace(
          /%20/g,
          "+"
        ),
        format: "json",
        polygon: 1,
        addressdetails: 1,
      },
    }
  );
  if (mapResponse.data) {
    const gymResult = await gym.queries.createGym({
      ...req.body,
      location: {
        type: "Point",
        coordinates: [mapResponse.data[0].lon, mapResponse.data[0].lat],
      },
    });
    return res.status(StatusOK).json({ id: gymResult._id });
  }
  return res
    .status(StatusBadRequest)
    .send("This address could not be located.");
};
