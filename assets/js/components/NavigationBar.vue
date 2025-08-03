<template>
  <header class="bg-white shadow-sm border-b border-gray-200">
    <div class="px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <div class="flex items-center">
          <h1 class="text-xl font-semibold text-gray-900">Ignite</h1>
        </div>
        
        <nav class="flex space-x-4">
          <UButton 
            v-for="item in navigation" 
            :key="item.name"
            :to="item.href"
            :variant="isActive(item.href) ? 'soft' : 'ghost'"
            color="gray"
            size="sm"
          >
            {{ item.name }}
          </UButton>
        </nav>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'NavigationBar',
  data() {
    return {
      navigation: [
        { name: 'Projects', href: '/' },
        { name: 'Settings', href: '/settings' }
      ]
    }
  },
  methods: {
    isActive(href) {
      // Simple active check - in a real app you'd use vue-router
      return window.location.pathname === href
    }
  }
}
</script>