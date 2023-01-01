let socket = {};

export async function connect(host, port) {
    socket = new WebSocket(`ws://${host}:${port}`);
    return new Promise((resolve, reject) => {
        setTimeout(()=>{reject()}, 2000);
        socket.addEventListener('open', () => {
            resolve(socket);
        }) });
}

export function onMessage(callback) {
	socket.onMessage(callback);
}
