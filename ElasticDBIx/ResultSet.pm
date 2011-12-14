package ElasticDBIx::ResultSet;
use strict;
use warnings;
use base qw(ElasticDBIx);

sub url {
    my $self = shift;

    my $url = $self->SUPER::url;

    return $url . '_bulk';
}

sub batch_index {
    my $self = shift;
    my $batch_size = shift || 50;

    my ($json, $rows) = ('', 0);
    
    my @fields = $self->searchable_fields;
    my $results = $self->search(undef, { select => \@fields });

    while (my $row = $results->next) {
        $rows++;
        $json .= $row->build_json;
        if ($rows == $batch_size) {
            $self->post($self->url, $json); 
            ($json, $rows) = ('', 0);
        }
    }

    1;
}

1;
