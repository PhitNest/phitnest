export class LocationEntity {
  type = "Point" as const;
  coordinates: [number, number];

  constructor(longitude: number, latitude: number) {
    this.coordinates = [longitude, latitude];
  }
}
