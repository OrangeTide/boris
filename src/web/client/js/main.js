async function connect(host, port) {
    socket = new WebSocket(`ws://${host}:${port}`);
    return new Promise((resolve, reject) => {
        setTimeout(()=>{reject("Timed out")}, 2000);
        socket.addEventListener('open', () => {
            resolve(socket);
        }) });
};


