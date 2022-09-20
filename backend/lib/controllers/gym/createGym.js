const { StatusOK, StatusBadRequest } = require('../../constants');

module.exports = async (req, res) => {
  const { createGym } = require('../../schema/gym')(res.locals.redis);
  const mapResponse = await axios.get(
    'https://nominatim.openstreetmap.org/search',
    {
      params: {
        q: `${req.body.address.streetAddress}, ${req.body.address.city}, ${req.body.address.state} ${req.body.address.zipCode}`.replace(
          /%20/g,
          '+'
        ),
        format: 'json',
        polygon: 1,
        addressdetails: 1,
      },
    }
  );
  if (mapResponse.data) {
    const id = await createGym(
      req.body.name,
      mapResponse.data[0].lon,
      mapResponse.data[0].lat
    );
    return res.status(StatusOK).json({ id: id });
  }
  return res
    .status(StatusBadRequest)
    .send('This address could not be located.');
};
