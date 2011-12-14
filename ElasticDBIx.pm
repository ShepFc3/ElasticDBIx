package ElasticDBIx;
use strict;
use warnings;
use LWP::UserAgent;
use Data::Dumper;

sub is_searchable {
    my $self = shift;

    my $klass = $self->result_class;

    return UNIVERSAL::can($klass, 'searchable');
}

sub searchable_fields {
    my $self = shift;

    my $klass = $self->result_class;
    my $cols = $klass->columns_info;
    my @searchable_fields = $klass->searchable;
    my @valid_fields;
    
    foreach my $field (@searchable_fields) { 
        if ($cols->{ $field }) {
            push(@valid_fields, $field);
        } else {
            warn "field $field not found in $klass";
        }
    }

    return @valid_fields;
}

sub user_agent {
    my $self = shift;

    return LWP::UserAgent->new(
        timeout => 600,
        agent => "SOS" 
    );
}

sub url {
    my $self = shift;

    my $type = $self->result_source->name;

    return "http://localhost:9200/sos/$type/";
}

sub post { 
    my ($self, $url, $content) = @_;

    my $request = HTTP::Request->new(POST => $url);
    $request->content_type('application/json');
    $request->content($content);

    return $self->user_agent->request($request);
}

sub primary_key {
    my $self = shift;

    my @ids = $self->result_source->primary_columns;
    return $ids[0];
}

1;
