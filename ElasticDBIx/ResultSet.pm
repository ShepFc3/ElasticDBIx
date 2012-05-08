package ElasticDBIx::ResultSet;
use strict;
use warnings;
use base qw(ElasticDBIx);

sub url {
    my $self = shift;

    my $url = $self->next::method;

    return $url . '_bulk';
}

sub batch_index {
    print "Batch Indexing...\n";
    my $self = shift;
    my $batch_size = shift || 50;
    my (@json, $rows) = ((), 0);

    return unless $self->has_searchable; 
    
    my @fields = $self->searchable_fields;
    my $results = $self->search(undef, { select => \@fields });

    while (my $row = $results->next) {
        $rows++;
        push(@json, $row->build_json);
        if ($rows == $batch_size) {
            print "Batched $rows rows\n";
            my $json_doc = join('\n', @json);
            $self->post($self->url, $json_doc); 
            (@json, $rows) = ((), 0);
        }
    }

    1;
}

1;
