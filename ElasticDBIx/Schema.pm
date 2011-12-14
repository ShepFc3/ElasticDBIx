package ElasticDBIx::Schema;

use strict;
use warnings;
use base qw(ElasticDBIx DBIx::Class::Schema);

sub index_all {
    my $self = shift;

    foreach my $source ($self->sources) {
        my $klass = $self->class($source);
        # class and source match needed when the class is not found
        if ($klass =~ m/($source)/ && UNIVERSAL::can($klass, 'searchable')) {
            print "Indexing source $source\n";
            $self->resultset($source)->batch_index;
        }
    }
}

1;
