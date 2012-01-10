## Installation
### Install as a submodule
    $ git submodule add git@github.com:ShepFc3/ElasticDBIx.git lib/ElasticDBIx
    $ git submodule init
    $ git submodule update

## Setup
### Copy elastic_search.yml.sample to elastic_search.yml
*edit file to reflect your elastic search settings*  

### Include the base directory
    use lib '/base/dir/lib';
*you only need this if lib is already in your path*  

### Include ElasticDBIx::Schema (optional) 
    use base qw(ElasticDBIx::Schema DBIx::Class::Schema);
*you need this if you want to use index_all*  

### Create ElasticResult 
**Create a new class that includes ElasticDBIx::Result and DBIx::Class::Core**
    package MyApp::ElasticResult;

    use strict;
    use warnings;
    use base qw(ElasticDBIx::Result DBIx::Class::Core);

    1;

### Use ElasticResult
    use base qw(MyApp::ElasticResult);

### Create ElasticResultSet (optional)
    package MyApp::ElasticResultSet;
    
    use strict;
    use warnings;
    use base qw(ElasticDBIx::ResultSet DBIx::Class::ResultSet);
    
    1;

### Use ElasticResult
    use base qw(MyApp::ElasticResultSet);

*use this to be able to batch_index a specific resultset*  
*neccessary when using ElasticDBIx::Schema*  

## Synopsis
### Batch index all DBIx classes with searchable fields
    $schema->index_all;

### Index all searchable fields for a row
    my $result = $schema->resultset('Artist')->find(1);
    $result->index();

### Batch index all searchable fields within the given resultset
    $schema->resultset('Artist')->batch_index;
