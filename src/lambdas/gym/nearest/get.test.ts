import { nearestGyms } from './get'

describe('helloWorld', () => {
  it('Should return hey', async () => {
    const result = await nearestGyms()
    expect(result.body).toBe('hey')
    expect(result.statusCode).toBe(200)
  })
})
