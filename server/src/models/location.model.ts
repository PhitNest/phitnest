export class LocationModel {
  type: string;
  coordinates: number[];

  constructor(lon: number, lat: number) {
    this.type = "Point";
    this.coordinates = [lon, lat];
  }
}
