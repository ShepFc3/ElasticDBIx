## Installation
### Install as a submodule
    $ git submodule add git@github.com:ShepFc3/ElasticDBIx.git lib/ElasticDBIx
    $ git submodule init
    $ git submodule update

## Setup
###Include the base directory
`use lib '/base/dir/lib';`
*you may not need this if lib is already in your path*

## Usage
### Batch index all DBIx classes with searchable fields
`$schema->index_all;`

### Index all searchable fields for a row
my $result = $schema->resultset('Artist')->find(1);
`$result->index();`

### Batch index all searchable fields within the given resultset
`$schema->resultset('Artist')->batch_index;`
