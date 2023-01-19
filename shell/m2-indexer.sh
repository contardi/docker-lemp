#!/bin/bash

usage() {
  echo "Store importer M2 v 2.0
  Usage
  $ shell/m2-indexer.sh {destination} @
   * destination: folder and host to be cleared, e.g. magento2.local
   * @: consecutives parameters, can be any of
    design_config_grid                       Design Config Grid
    customer_grid                            Customer Grid
    catalog_category_product                 Category Products
    catalog_product_category                 Product Categories
    catalogrule_rule                         Catalog Rule Product
    catalog_product_attribute                Product EAV
    cataloginventory_stock                   Stock
    inventory                                Inventory
    catalogrule_product                      Catalog Product Rule
    catalog_product_price                    Product Price
    catalogsearch_fulltext                   Catalog Search

  "
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "shell/m2-indexer.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

HOST=$1
INDEX=$2

echo "Indexing $HOST ${INDEX}"
docker compose exec -T --user www-data php81-fpm /bin/bash -c "cd /var/www/$HOST && bin/magento indexer:reindex ${INDEX}"

echo "$HOST - indexed"
