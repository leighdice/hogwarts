#!/bin/bash -e

function restoreVenueDB {
  echo "Restoring Venue DB"
  mongorestore --host=127.0.0.1
}
