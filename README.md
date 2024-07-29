
# Music Store Database

## Introduction
This project is a relational database schema for managing a music store. The database includes tables for storing information about artists, albums, tracks, customers, invoices, and other related entities.

## Table of Contents
1. [Installation](#installation)
2. [Usage](#usage)
3. [Database Schema](#database-schema)
4. [Features](#features)
5. [Dependencies](#dependencies)
6. [Configuration](#configuration)
7. [Documentation](#documentation)
8. [Examples](#examples)
9. [Troubleshooting](#troubleshooting)
10. [Contributors](#contributors)
11. [License](#license)

## Installation
To set up the Music Store Database, follow these steps:

1. **Navigate to your project directory:**
   ```bash
   cd /path/to/your/project
   ```
2. **Import the database schema:**
   Use the provided SQL file to create the database schema in your PostgreSQL server.
   ```bash
   psql -U username -d database_name -f Music_Store_database.sql
   ```

## Usage
The database can be used to store and manage information about artists, albums, tracks, customers, invoices, and playlists. You can query the database using SQL to extract useful information, generate reports, and more.

## Database Schema
The database schema includes the following tables:

- **Artist**: Contains artist information.
- **Album**: Contains album information linked to artists.
- **Track**: Contains track information, including details about the media type and genre.
- **Genre**: Stores genres associated with tracks.
- **MediaType**: Contains information about the media type of tracks.
- **Playlist**: Contains playlists created by users.
- **PlaylistTrack**: Maps tracks to playlists.
- **Customer**: Contains customer information, including contact details.
- **Employee**: Stores information about store employees.
- **Invoice**: Contains invoice information linked to customers.
- **InvoiceLine**: Maps tracks to invoices with quantity and pricing details.

![Database Schema](MusicDatabaseSchema.png)

## Features
- **Comprehensive Data Storage**: Store detailed information about music, customers, and sales.
- **Relational Structure**: Efficient querying through well-defined relationships between entities.
- **Scalability**: Easily extend the schema to include new entities or attributes.

## Dependencies
- **PostgreSQL**: The database schema and data are designed for a PostgreSQL database.
- **SQL Client**: A client tool to run and manage SQL queries (e.g., pgAdmin, DBeaver).

## Configuration
Ensure your PostgreSQL server is configured to accept the database schema. Adjust the SQL script to fit your server's requirements, such as database name, user permissions, and storage settings.

## Documentation
Refer to the SQL script `Music_Store_Query.sql` for example queries and further documentation on the database operations.

## Examples
Here are some example queries you can use:

- **Retrieve all tracks by a specific artist:**
  ```sql
  SELECT t.Name 
  FROM Track t
  JOIN Album a ON t.AlbumId = a.AlbumId
  JOIN Artist ar ON a.ArtistId = ar.ArtistId
  WHERE ar.Name = 'Artist Name';
  ```

- **Calculate total sales per genre:**
  ```sql
  SELECT g.Name, SUM(il.UnitPrice * il.Quantity) as TotalSales
  FROM InvoiceLine il
  JOIN Track t ON il.TrackId = t.TrackId
  JOIN Genre g ON t.GenreId = g.GenreId
  GROUP BY g.Name;
  ```

## Troubleshooting
- **Connection Issues**: Ensure your PostgreSQL server is running and accessible.
- **Permission Errors**: Verify that your user has sufficient permissions to execute the SQL scripts.
- **Data Import Errors**: Check the SQL syntax and compatibility with your PostgreSQL server version.

## Contributors
- [Krish Patel](krish042027@gmail.com)

## License
Specify the licensing terms under which the project is released. For example, MIT License, GPL, etc.
```
