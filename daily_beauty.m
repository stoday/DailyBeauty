
url = 'http://www.appledaily.com.tw/appledaily/bloglist/headline/30342177' ;
web_content = urlread( url ) ;
tokens = regexp( web_content, '<li class="fillup"><a href="/appledaily/article/headline/(.*?)">《今天我最美》今天我最美</a><time>(.*?)</time></li>', 'tokens' ) ;

outcome = cell( 20, 3 ) ;
date_str = cell( 20, 1 ) ;
for index = 1 : length( tokens ) 
    % url_target = strcat( 'http://www.appledaily.com.tw', tokens{ index }{ 1 }, '%E4%BB%8A%E5%A4%A9%E6%88%91%E6%9C%80%E7%BE%8E' ) ;
    % url_target = strcat( 'http://www.appledaily.com.tw', tokens{ index }{ 1 } ) ;
    adress_str = tokens{ index }{ 1 } ;
    adress_str = adress_str( 1 : end - 5 ) ;
    url_target = strcat( 'http://www.appledaily.com.tw/animation/beautyandbeast/beautyoftheday/', adress_str, '5' ) ;
    fprintf( tokens{ index }{ 2 } ) ;
    date_str{ index } = tokens{ index }{ 2 } ;
    web_content_target = urlread( url_target ) ;
    try
        clicked_times_cell = regexp( web_content_target, '<span class="vver">人氣：(.*?)</span>', 'tokens' ) ;
        clicked_times = str2double( cell2mat( clicked_times_cell{ 1 } ) ) ;
        disp( [ ' => ', num2str( clicked_times ) ] ) ;
        outcome( index, : ) = { tokens{ index }{ 2 }, clicked_times, url_target } ;
    catch me
        disp( [ 'Error: ', me.message ] ) ;
    end
end

bar( cell2mat( outcome( :, 2 ) ) ) ;
set( gca, 'XTick', 1 : 20 ) ;
set( gca, 'XTickLabel', date_str ) ;
rotateticklabel( gca ) ; grid on ;

hold on ;

outcome_save = outcome ;
outcome_save( :, 1 ) = regexprep( outcome_save( :, 1 ), '年|月|日', '-' ) ;
outcome_save( :, 1 ) = cellfun( @(x) x( 1 : end - 1 ), outcome_save( :, 1 ), 'UniformOutput', false ) ;
save( [ 'ClickedTimes_', datestr( now, 'yyyymmdd' ) ], 'outcome_save' ) ;

