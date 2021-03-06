package CIF::SDK::Format::Bro;

use strict;
use warnings;

use Mouse;
use Regexp::Common qw/net/;
use Regexp::Common qw /URI/;
use Regexp::Common::net::CIDR ();

with 'CIF::SDK::Format';

use Data::Dumper;

use constant type_hash => {
    'ipv4'  => 'ADDR',
    'url'   => 'URL',
    'fqdn'  => 'DOMAIN'
};
    
sub understands {
    my $self = shift;
    my $args = shift;

    return unless($args->{'format'});
    return 1 if($args->{'format'} eq 'bro');
}

sub process {
    my $self = shift;
    my $data = shift;

    my @text = ("#fields\tindicator\tindicator_type\tmeta.desc\tmeta.cif_confidence\tmeta.source");
    
    
    foreach my $d (@$data){
        
        my @array;
        foreach my $c (('observable','otype','tags','confidence','provider')){
            
            my $x = $d->{$c} || '-';
            if($c eq 'otype'){
                $x = 'Intel::'.type_hash->{$d->{$c}};
            }
            $x = join('|',@$x) if(ref($x) eq 'ARRAY');
            push(@array,$x);
        }
        push(@text,join("\t",@array));
    }
    return join("\n",@text);
}

__PACKAGE__->meta()->make_immutable();

1;
