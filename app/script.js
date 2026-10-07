import { rpc } from '@cococo/app'
export default {
  data() {
    return { count: null, busy: false, error: '' }
  },
  mounted() { this.refresh() },
  methods: {
    async request(method) {
      if (this.busy) return
      this.busy = true
      this.error = ''
      try {
        const result = await rpc(method)
        this.count = result.count
      } catch (error) {
        this.error = 'Could not confirm the saved value. Refresh before trying again. ' + (error.message || String(error))
      } finally {
        this.busy = false
      }
    },
    refresh() { return this.request('read') },
    increment() { return this.request('increment') }
  }
}
