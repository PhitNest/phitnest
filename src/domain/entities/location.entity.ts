export class LocationEntity {
  type = "Point";
  coordinates: [number, number];

  constructor(longitude: number, latitude: number) {
    this.coordinates = [longitude, latitude];
  }
}
