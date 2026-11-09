// A room's configured participant count must be filled, with exactly one
// opinion from each current member. Merely having one opinion is not enough.
export const isRoomReady = (
  memberLimit: number,
  memberIds: string[],
  authorIds: string[],
): boolean => {
  const members = new Set(memberIds)
  const authors = new Set(authorIds)
  return memberLimit >= 2 &&
    members.size === memberLimit &&
    authors.size === memberLimit &&
    [...members].every((id) => authors.has(id))
}
