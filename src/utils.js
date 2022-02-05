export function capitalise (string) {
  return string.charAt(0).toUpperCase() + string.slice(1)
}

export function getRandomEntry (items) {
  return items[Math.floor(Math.random() * items.length)]
}
