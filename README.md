# Public definitions and documentation for MaaS NRW

## Relevant standards

### GeoJson - Standard and default geo coordinate system specification

The [GeoJSON - Format](https://www.rfc-editor.org/rfc/rfc7946) is widely used within the community and relevant projects around MaaS (e.g. by both GTFS / GBFS, TOMP-API).

As an implication this project uses WS (longitude,latitude,[altitude]) as format for specifying coordinates, using the 
World Geodetic System 1984 (WGS 84) [WGS84] as a geographic coordinate reference system, with longitude and latitude units
of decimal degrees - if not otherwise stated

**Helpful tools and links**

1. https://geojson.io/ provides an editor for creating GeoJson - Data by drawing on a map 