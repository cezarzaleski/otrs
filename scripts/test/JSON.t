# --
# scripts/test/JSON.t - JSON module testscript
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: JSON.t,v 1.2 2010-04-15 10:51:51 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use Kernel::System::JSON;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw( $Self %Param );

$Self->{JSONObject} = Kernel::System::JSON->new( %{$Self} );

# Tests for JSON encode method
my @Tests = (
    {
        Input  => undef,
        Result => undef,
        Name   => 'JSON - undef test',
    },
    {
        Input  => '',
        Result => '""',
        Name   => 'JSON - empty test',
    },
    {
        Input  => 'Some Text',
        Result => '"Some Text"',
        Name   => 'JSON - simple'
    },
    {
        Input  => 42,
        Result => '42',
        Name   => 'JSON - simple'
    },
    {
        Input => [ 1, 2, "3", "Foo", 5 ],
        Result => '[1,2,"3","Foo",5]',
        Name   => 'JSON - simple'
    },
    {
        Input => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        Result => '{"Key1":"Value1","Key2":42,"Key3":"Another Value"}',
        Name   => 'JSON - simple'
    },
);

for my $Test (@Tests) {
    my $JSON = $Self->{JSONObject}->Encode(
        Data => $Test->{Input},
    );
    $Self->Is(
        $JSON,
        $Test->{Result},
        $Test->{Name},
    );
}

# JSON encode not so simple
my $JSON = $Self->{JSONObject}->Encode(
    Data => [
        [ 1, 2, "Foo", "Bar" ],
        {
            Key1 => 'Something',
            Key2 => [ "Foo", "Bar" ],
            Key3 => {
                Foo => 'Bar',
            },
            Key4 => {
                Bar => [ "f", "o", "o" ]
                }
        },
    ],
);

$Self->True(
    $JSON     =~ /\[1,2,"Foo","Bar"\]/ &&
        $JSON =~ /"Key1":"Something"/ &&
        $JSON =~ /"Key2":\["Foo","Bar"\]/ &&
        $JSON =~ /"Key3":{"Foo":"Bar"}/ &&
        $JSON =~ /"Key4":{"Bar":\["f","o","o"\]}/,
    'JSON - not so simple'
);

1;
