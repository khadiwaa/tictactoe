$( function(){
    var awaitingCompletionOfMove = false,
        player = 'x',
        gameComplete = false,
        board = $( document.querySelector( '#board' ) ),
        cells = $( document.querySelectorAll( '#board > div' )),
        messageBox = $( document.querySelector( '#messagebox' ) ),
        drawMessage = $( document.querySelector( '#draw_message' ) ),
        winningMessage = $( document.querySelector( '#winning_message' ) ),
        losingMessage = $( document.querySelector( '#losing_message' ) );

    function getBoard() {
        var board = '', move = '';
        cells.each( function( i, el ){
            move = $(el).attr('data-pos');
            board += move ? move : '_';
        });
        return board;
    }

    function rowColumnToPosition( row, col ) {
        return ( row * 3 ) + col + 1;
    }

    function findCell( position ) {
        return $( document.querySelector( '#pos' + position ) );
    }

    function togglePosition( element, player ) {
        element.attr( 'data-pos', player ).addClass( player + 'Play' );
    }

    function otherPlayer( player ) {
        return player == 'o' ? 'x' : 'o';
    }

    function displayWinner( data ) {
        if( data.winner && data.winning_moves ) {
            $( data.winning_moves).each(function( i, pos ){
                findCell( rowColumnToPosition( pos.row, pos.column )).addClass( 'winner' );
            });
            hideAllMessages();
            player == data.winner ? winningMessage.show() : losingMessage.show();
            displayMessage();
        }
    }

    function displayDraw() {
        hideAllMessages();
        drawMessage.show();
        displayMessage();
    }

    function hideAllMessages() {
        drawMessage.hide();
        winningMessage.hide();
        losingMessage.hide();
    }

    function displayMessage() {
        messageBox.addClass( 'blockElement' );
        setTimeout( function(){ messageBox.addClass( 'visible' ); }, 50 );
    }

    function hideMessage() {
        messageBox.removeClass( 'visible' ).addClass( 'hidden' );
        setTimeout( function(){ messageBox.removeClass( 'blockElement hidden' ); }, 1500 );
    }

    function handleMove( e ) {
        var element = $(e.target);
        if( awaitingCompletionOfMove || gameComplete || element.hasClass( 'oPlay' ) || element.hasClass( 'xPlay' ) ) {
            return;
        }
        awaitingCompletionOfMove = true;

        togglePosition( element, player )

        $.post(
            '/TicTacToe/compute_move',
            { board: getBoard(), player: otherPlayer( player ) },
            function( data ) {
                if( data.next_move && rowColumnToPosition( data.next_move.row, data.next_move.column )) {
                    togglePosition( findCell( rowColumnToPosition( data.next_move.row, data.next_move.column ) ), otherPlayer( player ) )
                }
                if( data.winner ) {
                    displayWinner( data );
                    gameComplete = true;
                } else if ( data.draw ) {
                    displayDraw();
                    gameComplete = true;
                }
                awaitingCompletionOfMove = false;
            }
        );
    };

    function handleWindowResize() {
        var base = Math.ceil( Math.max( 200, Math.min( jQuery(window).height(), jQuery(window).width() ) ) * .9 );
        var side = -1 * Math.ceil( base / 2 );
        board.height( base ).width( base );
        board.css( 'margin-left', side + 'px' ).css( 'margin-top', side + 'px' );
        board.css( 'font-size', Math.ceil( base / 6 ) + 'px' );
        messageBox.css( 'font-size', Math.max( Math.ceil( base / 18 ), 12 )+ 'px' );
    }

    function handlePlayAgainClick() {
        hideMessage();
        cells.each(function( i, cell ){
            $(cell).removeClass( 'oPlay xPlay winner' ).attr( 'data-pos', null );
        });
        gameComplete = false;
    }

    handleWindowResize();

    $( document.querySelector( '#message button' ) ).on( 'click', handlePlayAgainClick );
    cells.on( 'click', handleMove );
    $( window ).on( 'resize', handleWindowResize );
});