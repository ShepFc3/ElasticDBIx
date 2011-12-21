package ElasticDBIx::Result;
use strict;
use warnings;
use JSON;
use Data::Dumper;
use base qw(ElasticDBIx DBIx::Class::Row);

sub url {
    my $self = shift;

    my $pk = $self->primary_key;
    my $url = $self->SUPER::url;

    return $url . $self->$pk;
}

sub index {
    my $self = shift;

    my @fields = $self->searchable_fields;
    my %data = map { $_ => $self->{ '_column_data' }{ $_ } } @fields;

    my $json = encode_json(\%data);

    return $self->post($self->url, $json);
}

sub insert {
    my $self = shift;

    $self->SUPER::insert;

    return do {
        if ($self->is_searchable) {
            $self->index;
        } else {
            $self;
        }
    }

}

sub update {
    my $self = shift;

    $self->SUPER::update(@_);

    return do {
        if ($self->is_searchable) {
            $self->index;
        } else {
            $self;
        }
    }

}

sub delete {
    my $self = shift;

    $self->SUPER::delete;

    return do {
        if ($self->is_searchable) {
            $self->http_delete($self->url);
        } else {
            $self;
        }
    }
}

sub build_json {
    my $self = shift;
    my $pk = $self->primary_key;

    my @json = (encode_json({ index => { '_id' => $self->$pk } }));
    push(@json, encode_json($self->{ '_column_data' }));

    return @json;
}

1;
