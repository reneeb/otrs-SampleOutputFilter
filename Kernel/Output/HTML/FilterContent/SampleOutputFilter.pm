# --
# Copyright (C) 2017 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterContent::SampleOutputFilter;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::JSON;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(MainObject ConfigObject LogObject LayoutObject ParamObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{UserID}      = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get template name
    #my $Templatename = $Param{TemplateFile} || '';
    my $Action = $Self->{ParamObject}->GetParam( Param => 'Action' );

    return 1 if !$Action;
    return 1 if !$Param{Templates}->{$Action};

    my $JS = qq~
        <script type="text/javascript">//<![CDATA[
            console.debug( "Your javascript comes here" );

            Core.App.Ready( function() {
                alert('This javascript is run when the page is loaded');
                console.debug( "Core.App.Ready is an OTRS core function" );
            });
        //]]></script>
    ~;

    ${ $Param{Data} } =~ s{</body}{$JS</body};

    return 1;
}

1;
