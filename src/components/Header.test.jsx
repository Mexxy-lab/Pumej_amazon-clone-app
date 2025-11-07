import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import { useStateValue } from '../StateProvider';
import Header from './Header';

jest.mock('../StateProvider');

test('renders the cart icon', () => {
  useStateValue.mockReturnValue([{ basket: [] }, jest.fn()]);
  render(
    <MemoryRouter>
      <Header />
    </MemoryRouter>
  );

  // Look for the visible "Cart" text instead of alt text
  const cartLink = screen.getByText(/cart/i);
  expect(cartLink).toBeInTheDocument();
});

